#!/usr/bin/env ruby
require "open-uri"
require "net/http"
require "cgi"

class YbDownloader
  attr_reader :video_url, :video_stream_url, :video_title, :video_info

  BASE_YOUTUBE_INFO_URL = "http://www.youtube.com/get_video_info?video_id="

  class << self
    def fetch url
      new(url).call
    end
  end

  def initialize(url)
    @video_url = url
  end

  def call
    parse
    download
  end

  private

  def parse
    query_params = URI.parse(@video_url).query
    video_id = CGI.parse(query_params)["v"][0]

    uri =  URI("#{BASE_YOUTUBE_INFO_URL}#{video_id}")

    response = Net::HTTP.get(uri)
    @video_info = CGI.parse(response)
  end

  def fetch_title
    @video_title = @video_info['title'].first.gsub /[\W]/, "-"
  end

  def download(path_to_download = "~/Videos/#{fetch_title}.mp4")
    video_data = CGI.parse(@video_info["url_encoded_fmt_stream_map"].first)

    @stream_video_url = video_data['url'].first

    %x(curl -# "#{@stream_video_url}" -o #{path_to_download})
  end
end

YbDownloader.fetch ARGV[0]
