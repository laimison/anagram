require 'test_helper'

class AnagramsControllerTest < ActionDispatch::IntegrationTest  
  test 'GET /index - response code is success & page is not empty' do
    get "/index"
    
    assert_response :success
    assert_match(/[a-zA-Z0-9]/, response.body)
  end
  
  test 'GET /v1/anagrams?words=piecrust - response code is success & anagrams are correct' do
    get "/v1/anagrams", params: { words: ['piecrust'] }
    
    assert_response :success
    assert_match('{"piecrust"=>["crepitus", "cuprites", "pictures"]}', response.body)
  end  
  
  test 'GET /v1/anagrams?words=random_name - response code is success & anagrams not found' do
    get "/v1/anagrams", params: { words: ['random_name'] }
    
    assert_response :success
    assert_match('{"random_name"=>[]}', response.body)
  end
  
  test 'GET /v1/anagrams?words=random_name,crepitus,paste,kinship,enlist,boaster,random_name2 - response code is success & some anagrams found, some not' do
    get "/v1/anagrams", params: { words: ['random_name', 'crepitus', 'paste', 'kinship', 'enlist', 'boaster', 'random_name2'] }
    
    assert_response :success
    assert_match('{"random_name"=>[], "crepitus"=>["cuprites", "pictures", "piecrust"], "paste"=>["pates", "peats", "septa", "spate", "tapes", "tepas"], "kinship"=>["pinkish"], "enlist"=>["elints", "inlets", "listen", "silent", "tinsel"], "boaster"=>["boaters", "borates", "rebatos", "sorbate"], "random_name2"=>[]}', response.body)
  end
end