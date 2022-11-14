require 'csv'
require 'erb'

program_csv_path = "./ryosai2022.csv"
output_dir = "docs"

events_erb = <<EndOfContents
<html>
<head>
</head>
<body>
<div>

<style scoped>
.row-of-events {
  --bs-gutter-x: 1.5rem;
  --bs-gutter-y: 0;
  display: flex;
  flex-wrap: wrap;
  margin-top: calc(var(--bs-gutter-y) * -1);
  margin-right: calc(var(--bs-gutter-x)/ -2);
  margin-left: calc(var(--bs-gutter-x)/ -2);
}
.row-of-events>* {
  flex-shrink: 0;
  width: 100%;
  max-width: 100%;
  padding-right: calc(var(--bs-gutter-x)/ 2);
  padding-left: calc(var(--bs-gutter-x)/ 2);
  margin-top: var(--bs-gutter-y);
}
.card-of-event {
  background-color: #0d6efd!important;
  color: #fff!important;
  position: relative;
  display: flex;
  flex-direction: column;
  min-width: 0;
  word-wrap: break-word;
  background-color: #fff;
  background-clip: border-box;
  border: 1px solid rgba(0,0,0,.125);
  border-radius: 0.25rem;
  box-sizing:border-box;
  margin-bottom: 1rem;
}
.card-img-of-event {
  border-top-left-radius: calc(0.25rem - 1px);
  border-top-right-radius: calc(0.25rem - 1px);
  width: 100%;
  vertical-align: middle;
  box-sizing: border-box;
}
.card-body-of-event {
  flex: 1 1 auto;
  padding: 1rem 1rem;
  box-sizing: border-box;
  display: block;
}
.card-place-of-event {
  display: block;
  margin-block-start: 1em;
  margin-block-end: 1em;
  margin-inline-start: 0px;
  margin-inline-end: 0px;
  margin-top: 0;
  margin-bottom: 1rem;
  box-sizing: border-box;
}
.card-title-of-event {
  margin-bottom: 0.5rem;
  font-size: calc(1.275rem + .3vw);
}
@media (min-width: 1200px) {
  .card-title-of-event {
    font-size: 1.5rem;
  }
}
@media (min-width: 992px) {
  .col-one-third {
    flex: 0 0 auto;
    width: 33.3333333333%;
  }
}
</style>
<div style="width:100%;padding:30px;margin-right:auto;margin-left:auto;box-sizing: border-box;">
  <div class="row-of-events" style="box-sizing: border-box;">
<% events.each do |event| %>
    <div class="col-one-third" style="display:block;box-sizing:border-box;">
      <div class="card-of-event">
        <img class="card-img-of-event" src="/Kumanofes2022data/<%= event['image'] %>" alt="<%= %>">
        <div class="card-body-of-event">
          <h4 class="card-title-of-event"><%= event['name'] %></h4>
          <% if event['place'] && !event['place'].empty? %><p class="card-place-of-event">場所: <%= event['place'] %></p><% end %>
        </div>
      </div>
    </div>
<% end %>
  </div>
</div>

</div>
</body>
</html>
EndOfContents

if !File.exist?(program_csv_path)
  puts "[Error] #{program_csv_path} does not exist."
  exit
end

csv_data = CSV.read(program_csv_path, encoding: 'BOM|utf-8', headers: true)
# csv_data.each do |data|
#   puts "[#{data['start_day']}] #{data['id']} : #{data['name']} -- #{data['place']} "
# end

days = ['1125', '1126', '1127', '1128', '1129', '1130', '1201', '1202', '1203', '1204']
days.each do |day|
  events = csv_data.filter{ |d| d['start_day'] == day }
  b = binding
  File.open("#{output_dir}/events#{day}.html", 'w+') do |f|
    f.write(ERB.new(events_erb).result(b))
  end
end

# guerrilla
events = csv_data.filter{ |d| d['start_day'] == 'ゲリラ' }
File.open("#{output_dir}/guerrilla.html", 'w+') do |f|
  f.write(ERB.new(events_erb).result(binding))
end

# permanent
events = csv_data.filter{ |d| d['start_day'] == '常設' }
File.open("#{output_dir}/permanent.html", 'w+') do |f|
  f.write(ERB.new(events_erb).result(binding))
end

puts "Program ended"