#require 'gscholar'
require 'gentle-scholar'
require 'haml'

module Jekyll

  class GScholarPublicationTag < Liquid::Tag

    def initialize(tag_name, gscholar_pub_id, tokens)
      super
      @pub_id = gscholar_pub_id
    end

    def render(context)
      gpub = GentleScholar::Publication.get_from_http(@pub_id)

      # gather all names
      names_a = gpub[:authors].map do |n|
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

      if gpub[:cites]
        cite_str = "cited #{gpub[:cites]} times"
      else
        cite_str = ""
      end

      if [:volume, :issue, :pages].all? { |k| gpub.key? k } then
        pub_info = "(#{gpub[:volume]}:#{gpub[:issue]}), pp. #{gpub[:pages]}"
        link_str = 'find it online'
      else
        pub_info = ''
        link_str = 'forthcoming'
      end

      haml_code = Haml::Engine.new(%Q[
%div.pub
  %div.pub_ref
    #{names} #{gpub[:date].year}. “#{gpub[:title]}”
    %span.journal #{gpub[:journal]}
    %span #{pub_info}.
  %div.pub_url
    %a{ :href => "#{gpub[:article_url]}" }
      #{link_str}
  %div.pub_cit
    #{cite_str}
      ])

      haml_code.render
    end
  end

end

Liquid::Template.register_tag('scholar_pub', Jekyll::GScholarPublicationTag)
