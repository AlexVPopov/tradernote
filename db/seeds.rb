# frozen_string_literal: true
user = Fabricate(:user, auth_token: 'ca52d6bbeda7a0022a158ab4f1b86f9a')
Fabricate(:note, title: 'xxx', body: 'ggg, hhh, iii', user_tags: 'aaa,bbb,ccc', user: user)
Fabricate(:note, title: 'yyy', body: 'hhh, iii, jjj, lll', user_tags: 'bbb,ccc,ddd,fff', user: user)
Fabricate(:note, title: 'zzz', body: 'iii,jjj,kkk', user_tags: 'ccc,ddd,eee', user: user)
