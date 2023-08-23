require 'socket'
require 'openssl'

# คีย์และ IV สำหรับ AES-256 (จะต้องเหมือนกับเซิร์ฟเวอร์)
KEY = '01234567890123456789012345678901' # 32 bytes (256 bits)
IV = '0123456789012345' # 16 bytes

def encrypt(text)
  cipher = OpenSSL::Cipher::AES.new(256, :CBC)
  cipher.encrypt
  cipher.key = KEY
  cipher.iv = IV
  encrypted = cipher.update(text) + cipher.final
  encrypted
end

def decrypt(encrypted)
  decipher = OpenSSL::Cipher::AES.new(256, :CBC)
  decipher.decrypt
  decipher.key = KEY
  decipher.iv = IV
  decrypted = decipher.update(encrypted) + decipher.final
  decrypted
end

client = TCPSocket.new('localhost', 12345)
puts "Connected to server"

loop do
  # ใส่ข้อความที่ต้องการส่ง
  print "You: "
  message = gets&.chomp

  # เข้ารหัสข้อความก่อนส่ง
  encrypted_message = encrypt(message)

  # ส่งข้อมูลถอดรหัสไปยังเซิร์ฟเวอร์
  client.puts encrypted_message

  # รับข้อมูลจากเซิร์ฟเวอร์
  data = client.gets.chomp

  # ถอดรหัสข้อความที่ถูกส่งมา
  decrypted_data = decrypt(data)

  puts "Server: #{decrypted_data}"
end
