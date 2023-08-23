require 'socket'
require 'openssl'

# คีย์และ IV สำหรับ AES-256
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

server = TCPServer.new(12345)
puts "Server listening..."

client = server.accept
puts "Client connected"

loop do
 
 
  # รับข้อมูลจากไคลเอนต์
  data = client.gets&.chomp

  # ถอดรหัสข้อความที่ถูกส่งมา
  decrypted_data = decrypt(data)

  puts "Client: #{decrypted_data}"


  # ใส่ข้อความที่ต้องการส่ง
  print "You: "
  message = gets&.chomp

  # เข้ารหัสข้อความก่อนส่ง
  encrypted_message = encrypt(message)

  # ส่งข้อมูลถอดรหัสไปยังไคลเอนต์
  client.puts encrypted_message
end
