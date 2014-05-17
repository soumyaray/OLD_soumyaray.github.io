module Jekyll

  class GScholarPublicationTag < Liquid::Tag

    def initialize(tag_name, pub_id, tokens)
      super
      @pub_id = pub_id
    end

    def render(context)
      "should reference: " + @pub_id
    end
  end

end

Liquid::Template.register_tag('scholar_pub', Jekyll::GScholarPublicationTag)
