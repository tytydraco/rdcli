/// RealDebrid API endpoint for adding a magnet.
///
/// POST /torrents/addMagnet
/// Add a magnet link to download, return a 201 HTTP code.
/// Parameters:
///   - magnet        string  Magnet link.
///   - host          string  Hoster domain (retrieved from
///                           /torrents/availableHosts).
///
/// Return:
/// {
///   "id": "string",
///   "uri": "string" // URL of the created resource
/// }
///
/// Error codes:
///   - 400   Bad request (see error message).
///   - 401   Bad token (expired, invalid).
///   - 403   Permission denied (account locked, not premium).
///   - 503   Service unavailable (see error message).
const apiEndpointAddMagnet =
    'https://api.real-debrid.com/rest/1.0/torrents/addMagnet';

/// RealDebrid API endpoint for selecting files. Specify an ID.
///
/// POST /torrents/selectFiles/{id}
/// Select files of a torrent to start it, returns 204 HTTP code.
/// Parameters:
///   - files         string  Selected files IDs (comma separated) or "all".
///
/// Return:
/// None
///
/// Error codes:
///   - 202   Action already done.
///   - 400   Bad request (see error message).
///   - 401   Bad token (expired, invalid).
///   - 403   Permission denied (account locked, not premium).
///   - 404   Wrong parameter (invalid file id(s)) / Unknown resource (invalid
///           id).
const apiEndpointSelectFiles =
    'https://api.real-debrid.com/rest/1.0/torrents/selectFiles';

/// RealDebrid API endpoint for getting torrent info. Specify an ID.
///
/// GET /torrents/info/{id}
/// Get all information on the asked torrent.
///
/// Return:
/// [
///   {
///     "id": "string",
///     "filename": "string",
///     "original_filename": "string", // Original name of the torrent
///     "hash": "string", // SHA1 Hash of the torrent
///     "bytes": int, // Size of selected files only
///     "original_bytes": int, // Total size of the torrent
///     "host": "string", // Host main domain
///     "split": int, // Split size of links
///     "progress": int, // Possible values: 0 to 100
///     "status": "downloaded", // Current status of the torrent: magnet_error, magnet_conversion, waiting_files_selection, queued, downloading, downloaded, error, virus, compressing, uploading, dead
///     "added": "string", // jsonDate
///     "files": [
///       {
///         "id": int,
///         "path": "string", // Path to the file inside the torrent, starting with "/"
///         "bytes": int,
///         "selected": int // 0 or 1
///       },
///       {
///         "id": int,
///         "path": "string", // Path to the file inside the torrent, starting with "/"
///         "bytes": int,
///         "selected": int // 0 or 1
///       }
///     ],
///     "links": [
///       "string" // Host URL
///     ],
///     "ended": "string", // !! Only present when finished, jsonDate
///     "speed": int, // !! Only present in "downloading", "compressing", "uploading" status
///     "seeders": int // !! Only present in "downloading", "magnet_conversion" status
///   }
/// ]
///
/// Error codes:
///   - 401   Bad token (expired, invalid).
///   - 403   Permission denied (account locked).
const apiEndpointTorrentInfo =
    'https://api.real-debrid.com/rest/1.0/torrents/info';

/// RealDebrid API endpoint to unrestrict a link. Specify a link.
///
/// POST /unrestrict/link
/// Unrestrict a hoster link and get a new unrestricted link.
/// Parameters:
///   - link          string  The original hoster link.
///   - password      string  Password to unlock the file access hoster side.
///   - remote        string  0 or 1, use Remote traffic, dedicated servers and
///                           account sharing protections lifted.
///
/// Return:
/// {
///   "id": "string",
///   "filename": "string",
///   "mimeType": "string", // Mime Type of the file, guessed by the file extension
///   "filesize": int, // Filesize in bytes, 0 if unknown
///   "link": "string", // Original link
///   "host": "string", // Host main domain
///   "chunks": int, // Max Chunks allowed
///   "crc": int, // Disable / enable CRC check
///   "download": "string", // Generated link
///   "streamable": int // Is the file streamable on website
/// }
///
/// Error codes:
///   - 401   Bad token (expired, invalid).
///   - 403   Permission denied (account locked).
const apiEndpointUnrestrictLink =
    'https://api.real-debrid.com/rest/1.0/unrestrict/link';
