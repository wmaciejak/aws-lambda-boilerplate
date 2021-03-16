# How to create new Lambda Layer and provision it to function

From the perspective of AWS creating new Lambda Layers are pretty straightforward. We have to just compress gems and upload them to the AWS console. Unfortunately, when you using the free plan of Localstack you have to make workarounds to provide additional gems into your Lambda functions.

**This article is about "How to create lambda for this particular repository", not how to create Lambda Layers in general.**

In this example, we want to add `faraday` gem to our functions.

## Create and fill new Gemfile with Gems which you want to provision

This step is pretty simple. Go to your lambda directory, create a new Gemfile and add Faraday gem.

```bash
bundler init
bundle add faraday --skip-install
```

## Prepare custom layer with one particular script

**This step is NOT consistent with a standard way of Lambda Layer creation**

Now you have to copy prepared script which will automatically build whole layer during terraform init.

```bash
cp sources/build_custom_layer.sh sources/lambda1/build_custom_layer.sh
```

## Attach newly packaged layer to Lambda function (in our case `lambda_1`)

In this step, you have provide a definition of layers into Terraform. You have to add this code into `resources.tf`

```terraform
resource "null_resource" "build_layer_lambda1" {
  provisioner "local-exec" {
    command = "cd ../sources/lambda1 && sh build_custom_layer.sh"
  }
}

data "archive_file" "lambda1_zip" {
  type        = "zip"
  source_dir  = "../sources/lambda1"
  output_path = "../sources/lambda1/lambda1.rb.zip"
}
```

Remember to change `lambda1` to the name of your newly created lambda.

One additional thing that you have to do is to tell your lambda function that it should wait until the above-mentioned function will be finished. You can do it by adding this line to your `archive_file` lambda definition

`depends_on = [null_resource.build_layer_lambda1]`

Now your `archive_file` Lambda definition should looks like this:

```terraform
data "archive_file" "lambda1_zip" {
  type        = "zip"
  source_dir  = "../sources/lambda1"
  output_path = "../sources/lambda1/lambda1.rb.zip"

  depends_on = [null_resource.build_layer_lambda1]
}
```
