require 'gscholar'

module Jekyll

  class GScholarPublicationTag < Liquid::Tag

    def initialize(tag_name, gscholar_pub_id, tokens)
      super
      @pub_id = gscholar_pub_id
    end

    def render(context)
      gpub = GScholarPub.new(@pub_id)
      # "<tr>"\
      # "<td>citations: #{gpub.cites}</td>"\
      # "<td><a href=\"#{gpub.article_url}\">article link</a></td>"\
      # "</tr>"
      
      "<div class=\"pub_url\"><a href=\"#{gpub.article_url}\">find it online</a></div>"\
      "<div class=\"pub_cit\">cited #{gpub.cites} times</div>"
    end
  end

end

Liquid::Template.register_tag('scholar_pub', Jekyll::GScholarPublicationTag)
