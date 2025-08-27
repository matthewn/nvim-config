let s:save_cpo = &cpo
set cpo&vim

call matchup#util#append_match_words('{% *autoescape .*%}:{% *endautoescape *%}')
call matchup#util#append_match_words('{% *block .*%}:{% *endblock *%}')
call matchup#util#append_match_words('{% *comment .*%}:{% *endcomment *%}')
call matchup#util#append_match_words('{% *filter .*%}:{% *endfilter *%}')
call matchup#util#append_match_words('{% *for .*%}:{% *endfor *%}')
call matchup#util#append_match_words('{% *if .*%}:{% *else *%}:{% *endif *%}')
call matchup#util#append_match_words('{% *ifchanged .*%}:{% *else *%}:{% *endifchanged *%}')
call matchup#util#append_match_words('{% *ifequal .*%}:{% *else *%}:{% *endifequal *%}')
call matchup#util#append_match_words('{% *ifnotequal .*%}:{% *else *%}:{% *endifnotequal *%}')
call matchup#util#append_match_words('{% *spaceless .*%}:{% *endspaceless *%}')
call matchup#util#append_match_words('{% *verbatim .*%}:{% *endverbatim *%}')

let &cpo = s:save_cpo
