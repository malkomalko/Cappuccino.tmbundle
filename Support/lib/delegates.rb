class Cappuccino
  def self.delegates
    ENV['TM_CURRENT_WORD'] ||= ''
    {
      'currentClass' => ENV['TM_CURRENT_WORD'],
      'classArray' => [
        {
        'class' => 'CPTextField',
        'delegates' => [
          {'delegateName' => 'controlTextDidBeginEditing:'},
          {'delegateName' => 'controlTextDidChange:'},
          {'delegateName' => 'controlTextDidEndEditing:'},
          {'delegateName' => 'controlTextDidFocus:'},
          {'delegateName' => 'controlTextDidBlur:'}
        ]},
        {
        'class' => 'CPSecureTextField',
        'delegates' => [
          {'delegateName' => 'controlTextDidBeginEditing:'},
          {'delegateName' => 'controlTextDidChange:'},
          {'delegateName' => 'controlTextDidEndEditing:'},
          {'delegateName' => 'controlTextDidFocus:'},
          {'delegateName' => 'controlTextDidBlur:'}
        ]},
        {
        'class' => 'CPSearchField',
        'delegates' => [
          {'delegateName' => 'controlTextDidBeginEditing:'},
          {'delegateName' => 'controlTextDidChange:'},
          {'delegateName' => 'controlTextDidEndEditing:'},
          {'delegateName' => 'controlTextDidFocus:'},
          {'delegateName' => 'controlTextDidBlur:'}
        ]},
        {
        'class' => 'CPTableView',
        'delegates' => [
          {'delegateName' => 'tableViewColumnDidMove:'},
          {'delegateName' => 'tableViewColumnDidResize:'},
          {'delegateName' => 'tableViewSelectionDidChange:'},
          {'delegateName' => 'tableViewSelectionIsChanging:'},
          {'delegateName' => 'selectionShouldChangeInTableView:'},
          {'delegateName' => 'tableView:dataViewForTableColumn:row:'},
          {'delegateName' => 'tableView:didClickTableColumn:'},
          {'delegateName' => 'tableView:didDragTableColumn:'},
          {'delegateName' => 'tableView:heightOfRow:'},
          {'delegateName' => 'tableView:isGroupRow:'},
          {'delegateName' => 'tableView:mouseDownInHeaderOfTableColumn:'},
          {'delegateName' => 'tableView:nextTypeSelectMatchFromRow:toRow:forString:'},
          {'delegateName' => 'tableView:selectionIndexesForProposedSelection:'},
          {'delegateName' => 'tableView:shouldEditTableColumn:row:'},
          {'delegateName' => 'tableView:shouldSelectRow:'},
          {'delegateName' => 'tableView:shouldSelectTableColumn:'},
          {'delegateName' => 'tableView:shouldShowViewExpansionForTableColumn:row:'},
          {'delegateName' => 'tableView:shouldTrackView:forTableColumn:row:'},
          {'delegateName' => 'tableView:shouldTypeSelectForEvent:withCurrentSearchString:'},
          {'delegateName' => 'tableView:toolTipForView:rect:tableColumn:row:mouseLocation:'},
          {'delegateName' => 'tableView:typeSelectStringForTableColumn:row:'},
          {'delegateName' => 'tableView:willDisplayView:forTableColumn:row:'}
        ]},
        {
        'class' => 'CPOutlineView',
        'delegates' => [
          {'delegateName' => 'outlineViewColumnDidMove:'},
          {'delegateName' => 'outlineViewColumnDidResize:'},
          {'delegateName' => 'outlineViewSelectionDidChange:'},
          {'delegateName' => 'outlineViewSelectionIsChanging:'}
        ]},
      ]
    }
  end
end

# Template
=begin
{
'class' => '',
'delegates' => [
  {'delegateName' => ''},
  {'delegateName' => ''},
  {'delegateName' => ''},
  {'delegateName' => ''},
  {'delegateName' => ''},
]},
=end