%saveFigure Saves a figure as a properly cropped pdf /jpg / png
%
%   saveFigure(fileName,handle,dpi)
%
%   - fileName: Destination to write the figure to. The type of file is
%               determined by the extension. Currentley supported is pdf
%               jpg and png
%   - handle:  (optional) Handle of the figure to write to file.  If
%              omitted, the current figure is used.  Note that handles
%              are typically the figure number.
%   - dpi: (optional) Integer value of dots per inch (DPI).  Sets
%          resolution of output pdf.  Note that 150 dpi is the Matlab
%          default and this function's default, but 600 dpi is typical for
%          production-quality.
%
%   Saves figure as a pdf with margins cropped to match the figure size.
%
%   Based on save2pdf written by Gabe Hoffmann, gabe.hoffmann@gmail.com
%
function saveFigure(fileName,handle,dpi)

% Backup previous settings
prePaperType = get(handle,'PaperType');
prePaperUnits = get(handle,'PaperUnits');
preUnits = get(handle,'Units');
prePaperPosition = get(handle,'PaperPosition');
prePaperSize = get(handle,'PaperSize');

% Make changing paper type possible
set(handle,'PaperType','<custom>');

% Set units to all be the same
set(handle,'PaperUnits','inches');
set(handle,'Units','inches');

% Set the page size and position to match the figure's dimensions
paperPosition = get(handle,'PaperPosition');
position = get(handle,'Position');
set(handle,'PaperPosition',[0,0,position(3:4)]);
set(handle,'PaperSize',position(3:4));

% Save the pdf (this is the same method used by "saveas")
fileType = fileName(end-2:end);
switch fileType
    case 'png'
        print(handle,'-dpng',fileName,sprintf('-r%d',dpi));
    case 'jpg'
        print(handle,'-djpg',fileName,sprintf('-r%d',dpi));
    case 'pdf'
        print(handle,'-dpdf',fileName,sprintf('-r%d',dpi));
    otherwise
        error(['Unsupported file type ' fileType]);
end

% Restore the previous settings
set(handle,'PaperType',prePaperType);
set(handle,'PaperUnits',prePaperUnits);
set(handle,'Units',preUnits);
set(handle,'PaperPosition',prePaperPosition);
set(handle,'PaperSize',prePaperSize);

