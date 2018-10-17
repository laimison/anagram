module AnagramsGenerator
  class Generate
    def initialize
      puts "---- AnagramsGenerator::Generate executed on startup"
      File.write('/tmp/test3', 'executed')
      @myhash = { "laimis": "123" }
    end
    
    def mytest
      puts @myhash
    end
  end
end