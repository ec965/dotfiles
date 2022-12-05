;; use module-name as the key
(local cache {:module {} :macro {}})

;; string templates

;; auto generated header
(local t-auto-gen "-- This file is autogenerated by bulb\n")

(fn t-package-preload [module-name code-str]
  (string.format "package.preload['%s'] = package.preload['%s'] or function()
%s
end
" module-name module-name code-str module-name module-name))

;; caching fucntions

(fn clear-cache []
  "Reset the cache"
  (tset cache :module {})
  (tset cache :macro {})
  (vim.loop.unlink (. (require :builb.config) :cache-path)))

(fn add [cache-type]
  (fn [filename module-name code]
    (assert (= (type code) :string) (.. "Code is not a string for: " filename))
    (tset (. cache cache-type) module-name {: filename : module-name : code})))

(local add-macro (add :macro))
(local add-module (add :module))

(fn write-cache []
  ;; TODO: write macros to cache
  (let [{: write-file} (require :bulb.fs)
        cache-path (. (require :bulb.config) :cfg :cache-path)]
    (->> (accumulate [file-contents t-auto-gen _ {: module-name : code} (pairs cache.module)]
           (.. file-contents (t-package-preload module-name code)))
         (write-file cache-path))))

(fn gen-preload-cache []
  "Generate the preload file for all the files in the first runtime path"
  (let [{: get-fnl-files} (require :bulb.fs)
        {: compile-file} (require :bulb.compiler)
        {: get-module-name} (require :bulb.lutil)
        fnl-files (get-fnl-files (vim.fn.stdpath :config))]
    (each [_ filename (ipairs fnl-files)]
      (let [module-name (get-module-name filename)]
        ;; if this is a macro, we don't want to compile it
        ;; the macro searcher should always find our macro files before we start compiling
        (if (and (not= nil module-name) (= (. cache.macro module-name) nil))
            (->> (compile-file filename)
                 (add-module filename module-name))))))
  (write-cache))

{: gen-preload-cache : add-macro : clear-cache}
