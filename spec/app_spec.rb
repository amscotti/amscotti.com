require File.join(File.dirname(__FILE__), "..", "app.rb")
require 'rspec'
require 'rack/test'

set :environment, :test

describe 'amscotti.com site' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "should load home page" do
    get '/'
    last_response.should be_ok
    last_response.headers["Content-Type"].should == "text/html;charset=utf-8"
    last_response.body.should_not be_empty
    last_response.body.should match(/Hi, I'm Anthony Scotti./)
    
  end
  
  it "should return 404 when page cannot be found" do
    get '/404'
    last_response.status.should == 404
    last_response.body.should match(/I'm not sure what your looking for/)
  end
  
  it "should return 'status ok' when posting the right info to /contact" do
     post '/contact', {
       :email => "anthony.m.scotti@gmail.com",
       :name => "Anthony Scotti",
       :message => "This is a test from Rspec"
     }
     last_response.body.should == {:status => "ok"}.to_json
  end
  
  it "should return 'status error' when posting the wrong info to /contact" do
     post '/contact', {
       :email => "",
       :name => ""
     }
     last_response.body.should == {:status => "error"}.to_json
  end
  
end