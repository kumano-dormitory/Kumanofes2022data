require 'image_optim'
require 'csv'

program_csv_path = 'ryosai2022.csv'

image_optim = ImageOptim.new(allow_lossy: true, svgo: false, jpegoptim: {allow_lossy: true, max_quality: 50}, jpegrecompress: {allow_lossy: true, quality: 2})

if !File.exist?(program_csv_path)
  puts "[Error] #{program_csv_path} does not exist."
  exit
end

csv_data = CSV.read(program_csv_path, encoding: 'BOM|utf-8', headers: true)
csv_data.each do |event|
  path = "docs/#{event['image']}"
  if !File.exist?(path)
    puts "[Error] #{program_csv_path} does not exist."
  else
    image_optim.optimize_image!(path)
  end
end