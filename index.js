const path = require('bun:path');

let apiurl;
const args = process.argv.slice(2);

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
    //console.log('Uploading data...');
    const apiurl = await getApiUrl();
    const cwd = process.cwd();
    const input = args[1]; 
    const fullPath = path.resolve(cwd, input);
    console.log(`Resolved path: ${fullPath}`);
    const formData = new FormData();
    // Use Bun.file() to reference a local file
    const myFile = Bun.file(fullPath);

    formData.append("file", myFile);

    const response = await fetch(apiurl, {
    method: "POST",
    body: formData,
    });

    if (response.ok) {
    console.log(response);
    } else {
    console.error("Upload failed:", response);
    }

} else if (args[0]?.toLowerCase() === 'get') {
    console.log('Getting data...');
  // Add your get logic here
} else {
    console.error('Unknown command. Please use "Upload" or "Get".');
    process.exit(1);
}