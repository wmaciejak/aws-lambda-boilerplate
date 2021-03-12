# How to create new Lambda Layer and provision it to function

From the perspective of AWS creating new Lambda Layers are pretty straightforward. We have to just compress gems and upload them to the AWS console. Unfortunately, when you using the free plan of Localstack you have to make workarounds to provide additional gems into your Lambda functions.

**This article is about "How to create lambda for this particular repository", not how to create Lambda Layers in general.**

In this example, we want to add `faraday` gem to our functions.

## Create and fill new Gemfile with Gems which you want to provision

This step is pretty simple. You have to create a new directory inside `layers` directory by command `mkdir`

```bash
mkdir layers/faraday
cd layers/faraday
```

When we are inside this directory, just create a new Gemfile and add Faraday gem.

```bash
bundler init
bundle add faraday --skip-install
```

## Prepare custom layer with one particular script

**This step is NOT consistent with a standard way of Lambda Layer creation**

Now you have to create a layer package from prepared Gemfile. To do that, you have to copy the prepared script which does without spending time on it.

```bash
cp layers/build_custom_layer.sh layers/faraday/build_custom_layer.sh
cd layers/faraday
sh build_custom_layer.sh
```

It may take some time, but after this step, you have created Lambda Layer.

## Attach newly packaged layer to Lambda function (in our case `lambda_1`)

In this step, you have to copy your package to the directory with your lambda function and additionally provide a definition of this resource into Terraform.

First of all, copy layer:
```bash
cp layers/faraday/layer.zip sources/lambda1/layer.zip
```

Now you have to prepare an additional definition in Terraform.
You have to add this code into `resources.tf`

```terraform
resource "null_resource" "unzip_lambda1" {
  provisioner "local-exec" {
    command = "unzip -o -d ../sources/lambda1 ../sources/lambda1/layer.zip"
  }
}
```

Remember to change `lambda1` to the name of your newly created lambda.

One additional thing that you have to do is to tell your lambda function that it should wait until the above-mentioned function will be finished. You can do it by adding this line to your `archive_file` lambda definition

`  depends_on = [null_resource.unzip_lambda1]`

Now your `archive_file` Lambda definition should looks like this:

```terraform
data "archive_file" "lambda1_zip" {
  type        = "zip"
  source_dir  = "../sources/lambda1"
  output_path = "../sources/lambda1/lambda1.rb.zip"

  depends_on = [null_resource.unzip_lambda1]
}
```
