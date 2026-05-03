const path = require('bun:path');
import clipboard from "clipboardy";

let apiurl;
const args = process.argv.slice(2);
const maskapiurl = "https://link.ghostdrop.qzz.io/";
const apiurlcomposed = `${apiurl}/upload/`;
const apiurlgetcomposed = `${apiurl}/files/`;

if (args.length === 0) {
    console.error('Please provide a command: "Upload" or "Get"');
    process.exit(1);
}

async function getApiUrl() {
  const apiUrlProvider = "https://raw.githubusercontent.com/SaaranshDx/GhostDrop/main/serverurl";

  const res = await fetch(apiUrlProvider);

  if (!res.ok) {
    throw new Error("failed to fetch");
  }

  const url = await res.text();
  return url.trim();
}

if (args[0]?.toLowerCase() === 'upload') {
    const apiurl = await getApiUrl();
    const cwd = process.cwd();
    const input = args[1]; 
    const fullPath = path.resolve(cwd, input);
    // we dont need that in prod
    //console.log(`Resolved path: ${fullPath}`);
    const formData = new FormData();
    const myFile = Bun.file(fullPath);

    formData.append("file", myFile);

    const response = await fetch(apiurlcomposed, {
    method: "POST",
    body: formData,
    });
    
    const data = await response.json();

    const fileurl = `${maskapiurl}${data.id}/`;
// sorry for the great indentation i just wanted to make it look nice :(
    if (response.ok) {
        console.log(`✔ File uploaded: ${data.original_name}`);

        const expiryTime = new Date(
            Date.now() + data.expires_in_hours * 60 * 60 * 1000
        ).toLocaleString();

        console.log(`Expires at: ${expiryTime}`);

    try {
            await clipboard.write(fileurl);
            console.log(`🔗 Link copied to clipboard: ${fileurl}`);
    } catch {
            console.log(`🔗 Link: ${fileurl}`);
    }

    } else {
            const errorText = await response.text();
            console.error("Upload failed:", response.status, errorText);
    }

} else if (args[0]?.toLowerCase() === 'get') {
  const input = args[1];

  if (!input) {
    console.error("Provide a file URL or ID");
    process.exit(1);
  }

  // regex gaaaaaaaah
  const match = input.match(/(?:\/|^)([a-zA-Z0-9]{5,})\/?$/);

  if (!match) {
    console.error("Invalid URL or ID");
    process.exit(1);
  }

  const fileId = match[1];
  const apiurl = await getApiUrl();
  const fileUrl = `${apiurl}/files/${fileId}/`;

  console.log(`Fetching file: ${fileId}`);

  const response = await fetch(fileUrl);

  if (!response.ok) {
    const err = await response.text();
    console.error("Fetch failed:", response.status, err);
    process.exit(1);
  }

  // Try to get filename from headers
  const disposition = response.headers.get("content-disposition");

  let filename = fileId; 

  if (disposition) {
    const match = disposition.match(/filename="?(.+?)"?$/);
    if (match) {
      filename = match[1];
    }
  }

  let outputPath = path.resolve(process.cwd(), filename);

  // Check if file already exists and generate a unique name
  let counter = 1;
  const originalOutputPath = outputPath;
  while (await Bun.file(outputPath).exists()) {
    const ext = path.extname(filename);
    const base = path.basename(filename, ext);
    const dir = path.dirname(outputPath);
    outputPath = path.resolve(dir, `${base}_${counter}${ext}`);
    counter++;
  }

  const buffer = Buffer.from(await response.arrayBuffer());
  await Bun.write(outputPath, buffer);

  const savedFilename = path.basename(outputPath);
  console.log(`✔ File saved as: ${savedFilename}`);
  console.log(`📂 Path: ${outputPath}`);
} else {
    console.error('Unknown command. Please use "Upload" or "Get".');
    process.exit(1);
}