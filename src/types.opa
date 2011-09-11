type OpaShare.file = {
  name: string // file name
  size: int // file size
  content: binary // file content
  mimetype: string // file mimetype
  date_uploaded: Date.date // upload date
  date_downloaded: Date.date // last download date
  count: int // download counter
  password: option(string) // file password
}
