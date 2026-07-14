const fs = require('fs');
const path = require('path');
const https = require('https');

const cacheFile = path.join(__dirname, 'translation_cache.json');
let cache = {};

if (fs.existsSync(cacheFile)) {
  try {
    cache = JSON.parse(fs.readFileSync(cacheFile, 'utf8'));
  } catch (e) {
    cache = {};
  }
}

function saveCache() {
  fs.writeFileSync(cacheFile, JSON.stringify(cache, null, 2), 'utf8');
}

// Hàm gọi API dịch của Google (miễn phí, không cần key)
function translateText(text) {
  return new Promise((resolve) => {
    if (cache[text]) {
      return resolve(cache[text]);
    }

    const url = `https://translate.googleapis.com/translate_a/single?client=gtx&sl=zh-CN&tl=vi&dt=t&q=${encodeURIComponent(text)}`;
    
    https.get(url, (res) => {
      let data = '';
      res.on('data', (chunk) => { data += chunk; });
      res.on('end', () => {
        try {
          const parsed = JSON.parse(data);
          const translated = parsed[0].map(item => item[0]).join('');
          cache[text] = translated;
          saveCache();
          console.log(`Dịch: "${text}" -> "${translated}"`);
          resolve(translated);
        } catch (e) {
          // Nếu lỗi, trả về nguyên bản
          resolve(text);
        }
      });
    }).on('error', () => {
      resolve(text);
    });
  });
}

const targetDirs = [
  path.join(__dirname, 'ruoyi-ui', 'src', 'views', 'system'),
  path.join(__dirname, 'ruoyi-ui', 'src', 'views', 'monitor'),
  path.join(__dirname, 'ruoyi-ui', 'src', 'views', 'tool'),
  path.join(__dirname, 'ruoyi-ui', 'src', 'layout'),
  path.join(__dirname, 'ruoyi-ui', 'src', 'components')
];

// Tìm tất cả các file vue
function getVueFiles(dir, files = []) {
  if (!fs.existsSync(dir)) return files;
  const list = fs.readdirSync(dir);
  for (const file of list) {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);
    if (stat.isDirectory()) {
      getVueFiles(filePath, files);
    } else if (file.endsWith('.vue') || file.endsWith('.js')) {
      files.push(filePath);
    }
  }
  return files;
}

// Hàm chạy dịch hàng loạt
async function run() {
  console.log('Đang quét các file...');
  let allFiles = [];
  for (const dir of targetDirs) {
    getVueFiles(dir, allFiles);
  }
  console.log(`Tìm thấy ${allFiles.length} file Vue/JS.`);

  for (const filePath of allFiles) {
    let content = fs.readFileSync(filePath, 'utf8');
    
    // Tìm các chuỗi chữ Trung Quốc (từ 1 ký tự trở lên)
    const chineseRegex = /[\u4e00-\u9fa5]+/g;
    const matches = content.match(chineseRegex);
    
    if (matches && matches.length > 0) {
      // Loại bỏ trùng lặp trong file
      const uniqueMatches = Array.from(new Set(matches)).sort((a, b) => b.length - a.length);
      console.log(`\nĐang xử lý file: ${path.relative(__dirname, filePath)} (${uniqueMatches.length} từ tiếng Trung)`);
      
      let changed = false;
      for (const cnText of uniqueMatches) {
        // Không dịch nếu chỉ có 1 ký tự và là ký tự phổ biến dùng làm code/biến (nếu có)
        if (cnText.length === 1 && !/[\u4e00-\u9fa5]/.test(cnText)) continue;
        
        const viText = await translateText(cnText);
        if (viText && viText !== cnText) {
          // Thay thế chuỗi tiếng Trung bằng tiếng Việt
          const regex = new RegExp(cnText, 'g');
          content = content.replace(regex, viText);
          changed = true;
        }
      }
      
      if (changed) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Đã cập nhật file: ${path.relative(__dirname, filePath)}`);
      }
    }
  }
  console.log('\nHoàn tất dịch toàn bộ dự án!');
}

run();
