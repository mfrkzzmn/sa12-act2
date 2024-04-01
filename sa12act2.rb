require "httparty"

def get_max_starred_github_repo(username)
  url = "https://api.github.com/users/"+username+"/repos"
  results = HTTParty.get(url, format: :json)

  response = {}

  if results.code == 200
    total_repos = results.length
    max_star_index = 0
    max_count = 0

    (0...total_repos).each do |n|
      count = results[n]['stargazers_count']
      if count > max_count
        max_star_index = n
        max_count = count
      end
    end
    response["results"] = results[max_star_index]
  end
  response["code"] = results.code
  return response
end

def task_1
  username = "jasonrudolph"
  username = "mfrkzzmn"
  response = get_max_starred_github_repo(username)

  if response["code"] == 200
    puts response['results']['name']
    puts response['results']['description']
    puts response['results']['stargazers_count']
    puts response['results']['html_url']
  else
    puts "Something went wrong. The status code is #{response["code"]}"
  end
end

def get_coingecko_result(ticker)
  url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency="+ticker
  results = HTTParty.get(url, format: :json)

  response = {}
  result = []
  response["code"] = results.code
  results = results.sort_by{|x| -x['market_cap'].to_i}

  if response["code"] == 200
    (0...5).each do |n|
      crypto = {}
      crypto["name"] = results[n]['name']
      crypto["current_price"] = results[n]['current_price']
      crypto["market_cap"] = results[n]['market_cap']
      result.append(crypto)
    end

    response["results"] = result
  end
  return response
end

def task_2
  ticker = "usd"
  response = get_coingecko_result(ticker)

  if response["code"] == 200
    (0...5).each do |n|
      puts response['results'][n]['name']
      puts response['results'][n]['current_price']
      puts response['results'][n]['market_cap']
    end
  else
    puts "Something went wrong. The status code is #{response["code"]}"
  end
end

def get_world_time_zone_converter_result(area, location)
  url = "http://worldtimeapi.org/api/timezone/#{area}/#{location}"
  results = HTTParty.get(url, format: :json)

  response = {}
  result = []
  response["code"] = results.code

  response["timezone"] = results["timezone"]
  response["datetime"] = Time.parse(results["datetime"]).strftime('%Y-%m-%d %H:%M:%S')

  return response
end

def task_3
  query = "Europe/London"
  query_split = query.split('/')
  area = query_split[0]
  location = query_split[1]
  response = get_world_time_zone_converter_result(area, location)

  if response["code"] == 200
    puts "The current time in #{response['timezone']} is #{response['datetime']}"
  else
    puts "Something went wrong. The status code is #{response["code"]}"
  end
end

task_1
task_2
task_3
