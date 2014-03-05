require 'rubygems'
require 'sinatra'
require 'pdfkit'

PDFKit.configure do |config|
  config.wkhtmltopdf = '/opt/boxen/rbenv/shims/wkhtmltopdf'
  config.root_url = "http://localhost"
  config.verbose = false
  config.default_options = {
    :page_size => 'Legal',
    :print_media_type => true
  }
end

get '/' do
  @total_users = 5_400_00
  @total_repos = 11_300_000

  headers({ 'Content-Type' => 'application/pdf',
    'Content-Description' => 'File Transfer',
    'Content-Transfer-Encoding' => 'binary',
    'Content-Disposition' => "attachment;filename=\"factsheet.pdf\"",
    'Expires' => '0',
    'Pragma' => 'public' })
  kit = PDFKit.new(erb(:index))
  pdf = kit.to_pdf
end
