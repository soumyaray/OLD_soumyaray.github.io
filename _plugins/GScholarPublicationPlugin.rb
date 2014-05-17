require 'typhoeus'
require 'nokogiri'

module Jekyll

  class GScholarPublicationTag < Liquid::Tag

    def initialize(tag_name, pub_id, tokens)
      super
      @pub_id = pub_id
    end

    def render(context)
      auth_id, paper_id = @pub_id.split(/:/)
      url = "http://scholar.google.com/citations?view_op=view_citation" \
            + "&hl=en&user=" + auth_id \
            + "&citation_for_view=" + auth_id + ":" + paper_id
      req = Typhoeus::Request.new(url)
      res = req.run

      doc = Nokogiri::HTML(res.response_body)

      ## Cited-by HTML:
      # <div class="g-section" id="scholar_sec">
      #   <div class="cit-dt">Total citations</div>
      #   <div class="cit-dd">
      #     <a class="cit-dark-link" href="...">Cited by 15</a>
      #   </div>
      # </div>
      cites = doc.xpath("//div[contains(@id,'scholar_sec')]/div/a").text[/\d+/].to_i

      ## Chart HTML:
      # <div class="cit-dd">
      #   <img src="..." height="90" width="475" alt="">
      # </div>
      chart_url = doc.xpath("//div[contains(@class,'cit-dd')]/img").attr("src").value

      "  cites: #{cites}"
    end
  end

end

Liquid::Template.register_tag('scholar_pub', Jekyll::GScholarPublicationTag)
