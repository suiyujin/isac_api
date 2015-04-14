require 'csv'
require File.dirname(__FILE__) + '/web_api'

class GoogleNewsApi < WebApi
  def self.request(address)
    super(
      'http://ajax.googleapis.com',
      '/ajax/services/search/news',
      {
        v: '1.0',
        hl: 'ja',
        ned: 'jp',
        rsz: '8',
        q: make_query(address)
      }
    )
  end

  def self.make_query(address)
    words = ''
    CSV.foreach("#{File.dirname(__FILE__)}/words.csv", 'r') do |row|
      words = row.join(' OR ')
    end
    "#{address} AND (#{words})"
  end
end
