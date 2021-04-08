require "spec_helper"
require "../sources/lambda1/lambda1"

RSpec.describe "Lambda1" do
  describe "#dynamodb_client" do
    context "when ENV['LOCALSTACK_HOSTNAME'] is set up" do
      before { ENV["LOCALSTACK_HOSTNAME"] = "localstack" }

      it "correctly set up endpoint" do
        expect(dynamodb_client.config.endpoint.to_s).to eq("http://localstack:4566")
      end
    end

    context "when there is no env" do
      before { ENV["LOCALSTACK_HOSTNAME"] = nil }

      it "correctly set up endpoint" do
        expect(dynamodb_client.config.endpoint.to_s).to eq("https://dynamodb.eu-west-1.amazonaws.com")
      end
    end
  end

  # There is a few things which might be customized regarding `lambda_handler` invocation
  # 1. HTTP method - by default GET - often we want to execute methods like POST, PUT, DELETE etc.
  #    To change this method just define variable
  #     let(:http_method) { "POST" }
  # 2. Query Parameters - to define some parameters you have to define variable
  #     let(:query_params) do
  #       {
  #          user_id: "123"
  #       }
  #     end
  # 3. Headers - you can override or add new headers which lambda will take
  #     let(:headers) do
  #       super.merge({"Host" => "localhost:3000"})
  #     end

  describe "#lambda_handler" do
    subject { lambda_handler(event: event_params, context: context_params) }

    before { ENV["LOCALSTACK_HOSTNAME"] = "localstack" }

    it "return response status - 200" do
      expect(subject[:statusCode]).to eq 200
    end

    it "return expected body" do
      expect(JSON.parse(subject[:body])).to eq("Lambda 1 say 'OK'")
    end
  end
end
