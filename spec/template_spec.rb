require 'webrick'
require_relative '../lib/controller_base'

describe ControllerBase do
  before(:all) do
    class UsersController < ControllerBase
      def index
        @users = ["Me"]
      end
    end
  end
  after(:all) { Object.send(:remove_const, "UsersController") }

  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  let(:users_controller) { UsersController.new(req, res) }

  describe "#render_template" do
    before(:each) do
      users_controller.render_template(:index)
    end

    it "renders the html of the index view" do
      expect(users_controller.res.body).to include("ALL THE USERS")
      expect(users_controller.res.body).to include("<h1>")
      expect(users_controller.res.content_type).to eq("text/html")
    end

    describe "#already_built_response?" do
      let(:users_controller2) { UsersController.new(req, res) }

      it "is false before rendering" do
        expect(users_controller2.already_built_response?).to be_falsey
      end

      it "is true after rendering content" do
        users_controller2.render_template(:index)
        expect(users_controller2.already_built_response?).to be_truthy
      end

      it "raises an error when attempting to render twice" do
        users_controller2.render_template(:index)
        expect do
          users_controller2.render_template(:index)
        end.to raise_error
      end
    end
  end
end
