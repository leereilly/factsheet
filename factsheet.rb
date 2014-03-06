require 'rubygems'
require 'sinatra'
require 'pdfkit'
require 'numbers_and_words'
require 'alexa'

PDFKit.configure do |config|
  config.wkhtmltopdf = '/opt/boxen/rbenv/shims/wkhtmltopdf'
  config.root_url = "http://localhost"
  config.verbose = false
  config.default_options = {
    :page_size => 'Legal',
    :print_media_type => true
  }
end

def get_alexa_rank
  access_key_id     = ENV['AWS_ACCESS_KEY_ID']
  secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']

  client = Alexa::Client.new(access_key_id: access_key_id, secret_access_key: secret_access_key)
  url_info = client.url_info(url: "github.com")
  url_info.rank
end

get '/' do
  @total_users = 5_400_000
  @total_repos = 11_300_000
  @alexa_rank  = get_alexa_rank

  headers({ 'Content-Type' => 'application/pdf',
    'Content-Description' => 'File Transfer',
    'Content-Transfer-Encoding' => 'binary',
    'Content-Disposition' => "attachment;filename=\"factsheet.pdf\"",
    'Expires' => '0',
    'Pragma' => 'public' })
  kit = PDFKit.new(erb(:index))
  pdf = kit.to_pdf
end
