require 'gscholar'
require 'haml'

module Jekyll

  class GScholarPublicationTag < Liquid::Tag

    def initialize(tag_name, gscholar_pub_id, tokens)
      super
      @pub_id = gscholar_pub_id
    end

    def render(context)
      gpub = GScholarPub.new(@pub_id)

      # gather all names
      names_a = gpub.authors.map do |n|
        n.last + ', ' + (n.first(n.size-1)).reduce('') { |names, n2| names+n2[0]+'.' }
      end

      names = ''
      if names_a.length > 1 then
        all_but_last = names_a.first(names_a.length-1).join(', ')
        if names_a.length == 2 then append_s = 'and' else append_s = '&' end
        names = all_but_last + ", #{append_s} " + names_a.last
      else
        names = names_a[0]
      end

      haml_code = Haml::Engine.new(%Q[
%div.pub
  %div.pub_ref
    #{names} 2013. “#{gpub.title}”
    %span.journal #{gpub.journal}
    (#{gpub.volume}:#{gpub.issue}), pp. #{gpub.pages}.
  %div.pub_url
    %a{ :href => "#{gpub.article_url}" }
      find it online
  %div.pub_cit
    cited #{gpub.cites} times
      ])

      haml_code.render
    end
  end

end

Liquid::Template.register_tag('scholar_pub', Jekyll::GScholarPublicationTag)
