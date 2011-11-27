require 'rubygems'
require 'haml'
require 'json'
require 'aws-sdk'
require 'sinatra'

configure do
  AWS.config(:access_key_id => ENV['AWS_KEY'], :secret_access_key => ENV['AWS_SECRET'])
  set :topic_arn, ENV['TOPIC_ARN']
end

not_found do
  haml "404".to_sym
end

get '/' do
  haml :index
end

post '/contact' do
  content_type :json
  begin
    if params[:email].empty? || params[:name].empty? || params[:message].empty?
      raise "Null values"
    end
    
    message = """
    From: #{params[:name]}
    Email: #{params[:email]}

    =======================================
    #{params[:message]}
    """
    
    sns = AWS::SNS.new
    t = sns.topics[settings.topic_arn]
    t.publish(message, :subject => "Email from #{params[:name]}")
    status = {"status" => "ok"}
  rescue
    status = {"status" => "error"}
  end
  
  status.to_json
end

