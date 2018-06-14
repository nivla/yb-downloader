#!/usr/bin/env ruby
require "open-uri"
require "net/http"
require "cgi"

class YbDownloader
  attr_reader :youtube_video_url

  YOUTUBE_VIDEO_INFO_URL = "http://www.youtube.com/get_video_info?video_id="

  def self.download(youtube_video_url)
    new(youtube_video_url).call
  end

  def initialize(youtube_video_url)
    @youtube_video_url = youtube_video_url
  end

  def call
    download
  end

  private

  def download(path_to_download = "~/Videos/#{youtube_video_title}.mp4")
    %x(curl -# "#{youtube_downloable_video_url}" -o #{path_to_download})
  end

  def youtube_video_title
    youtube_video_info['title'].first.gsub /[\W]/, "-"
  end

  def youtube_downloable_video_url
    stream_map['url'].first
  end

  def stream_map
    CGI.parse(youtube_video_info["url_encoded_fmt_stream_map"].first)
  end

  def youtube_video_info
    uri =  URI("#{YOUTUBE_VIDEO_INFO_URL}#{youtube_video_id}")
    youtube_video_info_params = Net::HTTP.get(uri)
    @video_info ||= CGI.parse(youtube_video_info_params)
  end

  def youtube_video_id
    CGI.parse(query_params)["v"].first
  end

  def query_params
    URI.parse(youtube_video_url).query
  end
end

YbDownloader.download ARGV[0]