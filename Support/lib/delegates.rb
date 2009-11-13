class Cappuccino
  def self.delegates
    ENV['TM_CURRENT_WORD'] ||= ''
    {
      'currentClass' => ENV['TM_CURRENT_WORD'],
      'classArray' => [
        {
        'class' => 'CPTextField',
        'delegates' => [
          {'delegateName' => 'controlTextDidBeginEditing'},
          {'delegateName' => 'controlTextDidChange'},
          {'delegateName' => 'controlTextDidEndEditing'},
          {'delegateName' => 'controlTextDidFocus'},
          {'delegateName' => 'controlTextDidBlur'}]
        }
      ]
    }
  end
end
