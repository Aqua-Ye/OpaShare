/*  A simple file upload service built in Opa

    Copyright © 2011 Frederic Ye

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import stdlib.{blob}

on_upload(data, res) =
  file =
    match data
    ~{content filename fold_headers=_ name=_} ->
      match content()
      ~{content} -> some({
        name = filename
        size = String.length(content)
        content = content
        date_uploaded = Date.now()
        date_downloaded = Date.now()
        password = none
      })
      _ -> {none}
      end
    _ -> {none}
  //do jlog("{file}")
  //do init_upload()
  do match file
  ~{some} ->
    key = Db.fresh_key(@/files)
    do jlog("Uploaded @{key}")
    /files[key] <- some
  _ -> void
  _ = init_upload() // @error Reentrant routine
  res

upload_config() = { Upload.default_config(void) with
  fold_datas = on_upload
} : Upload.config(void)

init_upload() =
  Dom.transform([#upload <- Upload.make(upload_config())])

main() =
  <div id=#header>
    <h1>Welcome to OpaShare</h1>
  </div>
  <div id=#content>
    <div id=#upload onready={_->init_upload()}/>
  </div>

server = Server.one_page_bundle("OpaShare",
       [@static_resource_directory("resources")],
       ["resources/style.css"], main)
