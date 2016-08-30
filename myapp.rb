  require 'open-uri'
  require 'nokogiri'
  require 'sinatra'

  set :port, 3000

  get '/' do
  	erb :index
  end

  post '/set_url' do
  	domain = params[:domain] || 'bing.com'
  	erb :show_result, :locals => {'url' => domain}
	end

	get '/headings/*' do
		domain = params[:splat]
		domain_str = domain.join
		url = "http://#{domain_str}"

		doc = Nokogiri::HTML(open(url).read)
		@heads = doc.search('h1','h2').map{ |tag|
			case tag.name.downcase
			when 'h1'
				tag.text
			when 'h2'
				tag.text
			end
		}
		erb :headings
	end

	get '/links/*' do
		domain = params[:splat]
		domain_str = domain.join
		url = "http://#{domain_str}"
		
		doc = Nokogiri::HTML(open(url).read)
		@links = {}
		@links = doc.search('a').map{ |tag|
			case tag.name.downcase
			when 'a'
				tag
			end
		}
		erb :links
	end

