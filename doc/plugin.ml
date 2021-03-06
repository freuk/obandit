let mathjax_header =
  "<script type=\"text/x-mathjax-config\">\n\
   MathJax.Hub.Config({\n\
   tex2jax:{\
     inlineMath: [ ['$','$'], ['\\\\(','\\\\)'] ],\
     displayMath: [ ['$$','$$'], ['\\\\[','\\\\]'] ]\
   },\
   TeX:{\
     Macros: {\
       argmax: '\\\\mathop{\\\\rm arg\\\\,max}\\\\limits',\
     }\
   }\
   });\n\
   </script>\n\
   <script type=\"text/javascript\" \
   src=\"https://cdn.mathjax.org/mathjax/latest/MathJax.js?\
   config=TeX-AMS-MML_HTMLorMML\">\
   </script>\n"

let add_mathjax_to_header header b ?nav ?comments t =
  let b' = Buffer.create 64 in
  header b' ?nav ?comments t;
  let eoh = "</head>\n" in
  Buffer.add_substring b (Buffer.contents b') 0
    (Buffer.length b' - String.length eoh);
  Buffer.add_string b mathjax_header;
  Buffer.add_string b eoh

module Generator (G : Odoc_html.Html_generator) =
struct
  class html =
    object(self)
      inherit G.html as super
      method prepare_header module_list =
        super#prepare_header module_list; (* destructively modifies [header] *)
        header <- add_mathjax_to_header header
      method html_of_Latex buffer code = Buffer.add_string buffer code
    end
end

let () = Odoc_args.extend_html_generator
    (module Generator : Odoc_gen.Html_functor)
