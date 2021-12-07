require "scraperwiki"
require "mechanize"

url = "https://www.huonvalley.tas.gov.au/services/planning-2/planningnotices/"

agent = Mechanize.new
agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
page = agent.get(url)

page.at("table").search("tr").each do |tr|
  tds = tr.search("td")
  cells = tds.map {|td| td.inner_text.strip }
  next if cells.empty?
  record = {
    "council_reference" => cells[0].split(", ").first,
    "description" => cells[0].split(", ")[1..-1].join(", "),
    "address" => cells[1],
    "date_received" => Date.parse(cells[2]).to_s,
    "on_notice_to" => Date.parse(cells[3]).to_s,
    "date_scraped" => Date.today.to_s,
    "info_url" => tds[4].at("a")["href"]
  }
  puts "Saving #{record['council_reference']}..."
  ScraperWiki.save_sqlite(["council_reference"], record)
end
