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

import stdlib.{upload}

OpaShare = {{

  rec val upload_config = {
    Upload.default_config() with
    form_id = "share"
    process = process_upload
  } : Upload.config

  upload_done(key) =
    do Dom.clear_value(Dom.select_raw("#upload_form > input[name=filename]"))
    do Dom.transform([
      #msg <- "Download your file @ http://localhost:8080/files/{key}",
      #upload <- Upload.html(OpaShare.upload_config)
    ])
    void

  process_upload(data) =
    files = data.uploaded_files
    StringMap.iter(
      _, file ->
        os_file = {
          name = file.filename
          size = String.length(file.content)
          content = file.content
          mimetype = file.mimetype
          date_uploaded = Date.now()
          date_downloaded = Date.now()
          count = 0
          password = none
        } : OpaShare.file
        key = Db.fresh_key(@/files)
        do jlog("Uploaded @{key}")
        do /files[key] <- os_file
        upload_done(key)
    , files)

  upload_html() =
    Upload.html(OpaShare.upload_config)

}}

main() =
  <div id=#header>
    <h1>Welcome to OpaShare</h1>
  </div>
  <div id=#content>
    <div id=#upload>{OpaShare.upload_html()}</div>
    <div id=#msg></div>
  </div>

server = Server.one_page_bundle("OpaShare",
       [@static_resource_directory("resources")],
       ["resources/style.css"], main)
