type file = {
  name: string
  size: int
  content: binary
  date_uploaded: Date.date
  date_downloaded: Date.date
  password: option(string)
}
