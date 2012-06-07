<%@ Page Language="C#" AutoEventWireup="true"   %>
<%@ Import Namespace="System.CodeDom.Compiler" %>
<%@ Import Namespace="Microsoft.CSharp" %>
<%@ Import Namespace="Microsoft.VisualBasic" %>
<script runat=server>
    private ICodeCompiler GetCompiler()
    {
        switch (lstCompiler.SelectedValue)
        {
            case "csc":
                CSharpCodeProvider csc = new CSharpCodeProvider();
                return csc.CreateCompiler();
            case "vbc":
                VBCodeProvider vbc = new VBCodeProvider();
                return vbc.CreateCompiler();
            default:
                return null;
        }
    }
    protected void btnCompile_Click(object sender, EventArgs e)
    {
        CompilerResults results;
        ICodeCompiler icc = GetCompiler();
        CompilerParameters parameters = new CompilerParameters();
        string outpath = Server.MapPath(txtAssemblyName.Text + lstExtension.SelectedValue);


        parameters.GenerateExecutable = lstExtension.SelectedValue.Equals(".exe");
        parameters.OutputAssembly = outpath;
        parameters.GenerateInMemory = false;

        results = icc.CompileAssemblyFromSource(parameters, txtSource.Text);

        if (results.Errors.Count > 0)
        {
            Response.Write("<fieldset><legend>Error(s) found</legend><ol>");
            foreach (CompilerError err in results.Errors)
            {
                Response.Write("<li>" + err.ErrorText + "</li>");
            }
            Response.Write("</ol></fieldset>");
        }
        else
        {
            Response.Write("Build Successful, you can find your file at:<br /><strong>" + outpath + "</strong>");
        }
    }
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Online Compiler</title>
    <style>
    .tb {width:100%}
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    Assembly Name: <asp:TextBox ID="txtAssemblyName" runat="server">MyAssembly</asp:TextBox>
    <asp:DropDownList ID="lstExtension" runat="server">
        <asp:ListItem Value=".dll" Selected="true">Assembly (.dll)</asp:ListItem>
        <asp:ListItem Value=".exe">Executable (.exe)</asp:ListItem>
    </asp:DropDownList>
    
    Compile With: <asp:DropDownList ID="lstCompiler" runat=server>
        <asp:ListItem Value="csc" Selected=true>C#</asp:ListItem>
        <asp:ListItem Value="vbc">VB.NET</asp:ListItem>
        <asp:ListItem Value="cpp">C++</asp:ListItem>
    </asp:DropDownList>
    <br />
    <asp:TextBox CssClass="tb" Rows="10" Width="100%" TextMode="multiLine" ID="txtSource" runat="server"></asp:TextBox>
    <br />
    <asp:Button ID="btnCompile" Text = "compile" runat="server" OnClick="btnCompile_Click" />
    </div>
    </form>
    
</body>
</html>
