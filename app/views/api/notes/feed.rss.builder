xml.instruct!

xml.rss("version" => "2.0",
        "xmlns:dc" => "http://purl.org/dc/elements/1.1/",
        "xmlns:geo" => "http://www.w3.org/2003/01/geo/wgs84_pos#",
        "xmlns:georss" => "http://www.georss.org/georss") do
  xml.channel do
    xml.title t("api.notes.rss.title")
    if @min_lat.nil? && @min_lon.nil? && @max_lat.nil? && @max_lon.nil?
      xml.description t("api.notes.rss.description_all")
    else
      xml.description t("api.notes.rss.description_area", :min_lat => @min_lat, :min_lon => @min_lon, :max_lat => @max_lat, :max_lon => @max_lon)
    end
    xml.link url_for(:controller => "/site", :action => "index", :only_path => false)

    # Create single timeline
    feed_items = (@comments + @notes).sort_by(&:created_at).reverse

    # Output the feed
    feed_items.each do |item|
      if item.is_a?(NoteComment)
        location = describe_location(item.note.lat, item.note.lon, 14, locale)

        xml.item do
          xml.title t("api.notes.rss.#{item.event}", :place => location)

          xml.link url_for(:controller => "/notes", :action => "show", :id => item.note.id, :anchor => "c#{item.id}", :only_path => false)
          xml.guid url_for(:controller => "/notes", :action => "show", :id => item.note.id, :anchor => "c#{item.id}", :only_path => false)

          xml.description do
            xml.cdata! render(:partial => "entry", :object => item, :formats => [:html])
          end

          xml.dc :creator, item.author.display_name if item.author

          xml.pubDate item.created_at.to_fs(:rfc822)
          xml.geo :lat, item.note.lat
          xml.geo :long, item.note.lon
          xml.georss :point, "#{item.note.lat} #{item.note.lon}"
        end
      else
        location = describe_location(item.lat, item.lon, 14, locale)

        xml.item do
          xml.title t("api.notes.rss.opened", :place => location)

          xml.link url_for(:controller => "/notes", :action => "show", :id => item.id, :only_path => false)
          xml.guid url_for(:controller => "/notes", :action => "show", :id => item.id, :only_path => false)

          xml.description do
            xml.cdata! render(:partial => "entry", :object => item, :formats => [:html])
          end

          xml.dc :creator, item.author.display_name if item.author

          xml.pubDate item.created_at.to_fs(:rfc822)
          xml.geo :lat, item.lat
          xml.geo :long, item.lon
          xml.georss :point, "#{item.lat} #{item.lon}"
        end
      end
    end
  end
end
