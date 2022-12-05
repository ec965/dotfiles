(local M {:cache {:module {} :macro {}}})

;; auto generated header
(local t-auto-gen "-- This file is autogenerated by bulb\n")

(macro t-package-preload [module-name code-str]
  `(string.format (.. "package.preload['%s'] = package.preload['%s'] or function()"
                      "  return assert(loadstring('%s', '%s')(), 'Failed to load module: ' .. '%s')"
                      "end\n") ,module-name ,module-name
                  ,code-str ,module-name ,module-name))

(fn add [cache-type]
  (fn [filename module-name code]
    (tset (. M :cache cache-type) filename {: filename : module-name : code})))

(fn M.write-cache []
  (let [{: write-file} (require :bulb.fs)
        cache-path (. (require :bulb.config) :cfg :cache-path)]
    (->> (accumulate [file-contents t-auto-gen _ {: module-name : code} (pairs M.cache.module)]
           (.. file-contents (t-package-preload module-name code)))
         (write-file cache-path))))

(tset M :add-module (add :module))
(tset M :add-macro (add :macro))

M
