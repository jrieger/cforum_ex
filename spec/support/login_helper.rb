# -*- coding: utf-8 -*-

def login_user(user)
  post new_user_session_path, {
         'user[login]' => user.email,
         'user[password]' => user.password
       }
end

# eof
