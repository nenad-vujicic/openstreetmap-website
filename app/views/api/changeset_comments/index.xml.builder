xml.instruct! :xml, :version => "1.0"

xml.osm(OSM::API.new.xml_root_attributes) do |osm|
  @comments.includes(:author).each do |comment|
    osm << render(comment)
  end
end
