
using System.Text;
using System;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using System.Diagnostics;

string list = "\n";

EnsureDataLoaded();

Data.GeneralInfo.DisplayName.Content += " (running cylindoO)";

Directory.CreateDirectory("./patches");

ThreadLocal<GlobalDecompileContext> DECOMPILE_CONTEXT = new ThreadLocal<GlobalDecompileContext>(() => new GlobalDecompileContext(Data, false));

for (int i = 0; i < Data.Code.Count; i++) {
	UndertaleCode code = Data.Code[i];
	if (File.Exists("./patches/"+code.Name.Content+".gml")) {
		string file = File.ReadAllText("./patches/"+code.Name.Content+".gml");
		code.ReplaceGML(Decompiler.Decompile(code, DECOMPILE_CONTEXT.Value)+"\n"+file, Data);
		ChangeSelection(code);
		list += code.Name.Content+"\n";
	}
}
// ScriptMessage(Data.Code[0].Name.Content+":\n\n"+Decompiler.Decompile(Data.Code[0], DECOMPILE_CONTEXT.Value));
ScriptMessage("Scripts patched:"+list);