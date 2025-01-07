%% Uložení otevřených figur
FolderName = tempdir;   % Your destination folder
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName   = get(FigHandle, 'Name');
  %savefig(FigHandle, fullfile(FolderName, FigName, '.eps'));
  set(0, 'CurrentFigure', FigHandle);
  saveas(FigHandle, fullfile(FolderName, [FigName, '.eps']), 'epsc');
end

clear FolderName FigList FigHandle FigName iFig