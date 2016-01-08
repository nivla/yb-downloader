#!/usr/bin/env ruby
require "open-uri"
require "net/http"
require "cgi"


query_params = URI.parse(ARGV[0]).query
video_id = CGI.parse(query_params)["v"][0]

youtube_url_info = "http://www.youtube.com/get_video_info?video_id=#{video_id}"

uri =  URI(youtube_url_info)
response = Net::HTTP.get(uri)
info = CGI.parse(response)

video_title = info['title'].first
video_data = CGI.parse(info["url_encoded_fmt_stream_map"].first)

video_link = video_data['url'].first

video_file = File.open("#{video_title}.mp4","w")
bytes = open(video_link).read
video_file.write(bytes)
video_file.close

