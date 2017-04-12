
(* OCaml-CRF --- Conditional random field library in OCaml
   Copyright (C) 2015 Akinori ABE <abe@sf.ecei.tohoku.ac.jp>

   This program is free software; you can redistribute it and/or modify it under
   the terms of the GNU General Public License as published by the Free Software
   Foundation; either version 3 of the License, or (at your option) any later
   version.

   This program is distributed in the hope that it will be useful, but WITHOUT
   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
   FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
   details.

   You should have received a copy of the GNU General Public License along with
   this program. If not, see <http://www.gnu.org/licenses/>. *)

(** MathJax header *)
let mathjax_header =
  "<script type=\"text/x-mathjax-config\">\n\
   MathJax.Hub.Config({\n\
   tex2jax:{\
     inlineMath: [ ['$','$'], ['\\\\(','\\\\)'] ],\
     displayMath: [ ['$$','$$'], ['\\\\[','\\\\]'] ]\
   },\
   TeX:{\
     Macros: {\
       C: '{\\\\mathbb C}',\
       R: '{\\\\mathbb R}',\
       Q: '{\\\\mathbb Q}',\
       Z: '{\\\\mathbb Z}',\
       bm: ['{\\\\boldsymbol #1}', 1],\
       argmax: '\\\\mathop{\\\\rm arg\\\\,max}\\\\limits',\
       argmin: '\\\\mathop{\\\\rm arg\\\\,min}\\\\limits'\
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
  header b' ?nav ?comments t; (* Generate the original header. *)
  let eoh = "</head>\n" in (* The string at the end of a header. *)
  Buffer.add_substring b (Buffer.contents b') 0
    (Buffer.length b' - String.length eoh); (* Remove [eoh]. *)
  Buffer.add_string b mathjax_header;
  Buffer.add_string b eoh (* Append [eoh] *)

module Generator (G : Odoc_html.Html_generator) =
struct
  class html =
    object(self)
      inherit G.html as super

      method prepare_header module_list =
        print_endline "*** Using mathjax custom ocamldoc generator.";
        super#prepare_header module_list; (* destructively modifies [header] *)
        header <- add_mathjax_to_header header

      method html_of_Latex buffer code = Buffer.add_string buffer code
    end
end

let () = Odoc_args.extend_html_generator
    (module Generator : Odoc_gen.Html_functor)
