(fn nmap! [lhs rhs buffer]
  `(vim.keymap.set :n ,lhs ,rhs {:noremap true :silent true :buffer ,buffer}))

(fn vmap! [lhs rhs buffer]
  `(vim.keymap.set :v ,lhs ,rhs {:noremap true :silent true :buffer ,buffer}))

(fn xmap! [lhs rhs buffer]
  `(vim.keymap.set :x ,lhs ,rhs {:noremap true :silent true :buffer ,buffer}))

(fn tmap! [lhs rhs buffer]
  `(vim.keymap.set :t ,lhs ,rhs {:noremap true :silent true :buffer ,buffer}))

(fn map! [modes lhs rhs buffer]
  `(vim.keymap.set ,modes ,lhs ,rhs
                   {:noremap true :silent true :buffer ,buffer}))

(fn req! [lib val]
  `(. (require ,lib) ,val))

(fn command! [name command opts]
  (let [opts (or opts {})]
    `(vim.api.nvim_create_user_command ,name ,command ,opts)))

{: nmap! : vmap! : req! : map! : command! : xmap! : tmap!}
