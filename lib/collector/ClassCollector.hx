/*
 *                            _/                                                    _/   
 *       _/_/_/      _/_/    _/  _/    _/    _/_/_/    _/_/    _/_/_/      _/_/_/  _/    
 *      _/    _/  _/    _/  _/  _/    _/  _/    _/  _/    _/  _/    _/  _/    _/  _/     
 *     _/    _/  _/    _/  _/  _/    _/  _/    _/  _/    _/  _/    _/  _/    _/  _/      
 *    _/_/_/      _/_/    _/    _/_/_/    _/_/_/    _/_/    _/    _/    _/_/_/  _/       
 *   _/                            _/        _/                                          
 *  _/                        _/_/      _/_/                                             
 *                                                                                       
 * POLYGONAL - A HAXE LIBRARY FOR GAME DEVELOPERS
 * Copyright (c) 2009-2010 Michael Baczynski, http://www.polygonal.de
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
import neko.FileSystem;
import neko.io.FileOutput;
import neko.Lib;
import neko.Sys;

class ClassCollector
{
	static var _extension:EReg;
	
	static var _excludePackage:EReg = null;
	static var _include:EReg = null;
	
	public static function main():Void
	{
		var args = Sys.args();
		
		if (args.length < 2)
		{
			Lib.println("ClassCollector 1.01 - (c) 2009 Michael Baczynski");
			Lib.println("  Usage : ClassCollector [base directory] [output file] [options]");
			Lib.println("  Options: ");
			Lib.println("        -include       package Includes a package or file");
			Lib.println("        -exclude       package Excludes a package or file");
			Lib.println("        -class         generates a class with import statements using [output file] as class name");
			Lib.println("        -property name generates a property file using [output file] as file name and [name] as property name");
			Lib.println("  Sample usage:");
			Lib.println("        neko ClassCollector.n ./src output.properties -property classList -include a.b.c -include a/b/c/Class.hx -exclude a.b.c -exclude a/b/c/Class.hx");
			Lib.println("        neko ClassCollector.n ./src MyClass.hx -class -include a.b.c -include a/b/c/Class.hx -exclude a.b.c -exclude a/b/c/Class.hx");
			Sys.exit(-1);
			return;
		}
		
		//base directory
		var dir = args.shift();
		if (dir == "-include" || dir == "-exclude")
		{
			Lib.println("Error: invalid base directory " + args[0]);
			Sys.exit(-1);
			return;
		}
		
		if (dir.charAt(dir.length - 1) == "/" || dir.charAt(dir.length - 1) == "\\")
			dir = dir.substr(0, dir.length - 1);
		
		//output file
		var out = args.shift();
		if (dir == "-include" || dir == "-exclude")
		{
			Lib.println("Error: invalid output file " + args[0]);
			Sys.exit(-1);
			return;
		}
		
		//create output directory if not exists
		var outputDir = neko.FileSystem.fullPath(out);
		outputDir = outputDir.substr(0, outputDir.lastIndexOf("\\"));
		
		//read options
		var includePackages = new Array<String>();
		var includeFiles    = new Array<String>();
		var excludePackages = new Array<String>();
		var excludeFiles    = new Array<String>();
		var genClass        = false;
		var genProperty     = false;
		var propertyName    = "classes";
		while (args.length > 0)
		{
			var option = args.shift();
			if (option == "-include")
			{
				var name = args.shift();
				
				if (~/\\/g.match(name))
					name = ~/\\/g.replace(name, "/");
				
				if (FileSystem.exists(neko.FileSystem.fullPath(dir + "/" + name)))
					includeFiles.push(dir + "/" + name);
				else
					includePackages.push(name);
			}
			else if (option == "-exclude")
			{
				var name = args.shift();
				
				if (~/\\/g.match(name))
					name = ~/\\/g.replace(name, "/");
				
				if (FileSystem.exists(neko.FileSystem.fullPath(dir + "/" + name)))
					excludeFiles.push(dir + "/" + name);
				else
					excludePackages.push(name);
			}
			else if (option == "-class")
			{
				if (genProperty)
				{
					Lib.println("Error: invalid option " + option);
					Sys.exit(-1);
					return;
				}
				
				genClass = true;
			}
			else if (option == "-property")
			{
				if (genClass)
				{
					Lib.println("Error: invalid option " + option);
					Sys.exit(-1);
					return;
				}
				
				genProperty = true;
				propertyName = args.shift();
			}
			else
			{
				Lib.println("Error: invalid option " + option);
				Sys.exit(-1);
				return;
			}
		}
		
		try
		{
			var fileList = new Array<String>();
			if (includePackages.length > 0)
			{
				for (pkg in includePackages)
					dumpInclude(dir, fileList, pkg.split("."), 0);
			}
			else
				dump(dir, fileList);
			
			var filteredFileList = new Array<String>();
			if (excludePackages.length > 0)
			{
				var t = excludePackages.join("|");
				t = ~/\./g.replace(t, "\\.");
				var exclude = new EReg(t, "g");
				for (file in fileList)
				{
					var t = ~/\//g.replace(file, ".");
					if (!exclude.match(t))
						filteredFileList.push(file);
				}
			}
			else
				filteredFileList = fileList;
			
			for (file in includeFiles)
				filteredFileList.push(file);
			
			var tmp = new Array<String>();
			for (file in filteredFileList)
			{
				var exclude = false;
				for (e in excludeFiles)
				{
					if (file == e)
					{
						exclude = true;
						Lib.println("- " + file);
						break;
					}
				}
				
				if (exclude) continue;
				
				Lib.println("+ " + file);
				tmp.push(file);
			}
			
			filteredFileList = tmp;
			
			var output = new Array<String>();
			
			for (i in 0...filteredFileList.length)
			{
				var s = filteredFileList[i];
				
				//remove source directory
				s = s.substr(dir.length + 1);
				
				//replace "/" in path with "." and remove extension ".hx"
				s = ~/\//g.replace(s, ".");
				s = ~/\.hx/g.replace(s, "");
				Lib.println(s);
				output.push(s);
			}
			
			var s = "";
			
			if (genClass)
			{
				for (i in output)
					s += "import " + i + ";\n";
				
				var possibleName = out.substr(0, out.length - 3);
				var parts = possibleName.split("/");
				var name = parts[parts.length - 1];
				
				s += "class " +  name + "{}"; //remove .hx
			}
			else if (genProperty)
			{
				Lib.println("properties file written: " + out);
				s += propertyName + " = " + output.join(" ") + "\n";
			}
			
			var fout:FileOutput = neko.io.File.write(out, false);
			fout.writeString(s);
			fout.close();
		}
		catch (e:Dynamic)
		{
			Sys.exit(-1);
		}
	}
	
	static function dump(dir:String, files:Array<String>):Void
	{
		var a = FileSystem.readDirectory(dir);
		for (i in 0...a.length)
		{
			var name = a[i];
			var path = dir + "/" + name;
			
			if(FileSystem.isDirectory(path)) {
				if (!isSvn(path))
					dump(path, files);
			} else {
				if (isHx(path) && !isSvn(path))
				{
					files.push(path);
				}
			}
		}
	}
	
	static function dumpInclude(dir:String, files:Array<String>, pkg:Array<String>, level:Int):Void
	{
		var a = FileSystem.readDirectory(dir);
		for (i in 0...a.length)
		{
			var name = a[i];
			var path = dir + "/" + name;
			
			if(FileSystem.isDirectory(path)) {
				if (!isSvn(path))
				{
					if (name != pkg[level] && level < pkg.length) continue;
					dumpInclude(path, files, pkg, level + 1);
				}
			} else {
				if (isHx(path) && !isSvn(path))
				{
					if (level >= pkg.length) files.push(path);
				}
			}
		}
	}
	
	inline static function isHx(x:String):Bool
	{
		return ~/\.hx/g.match(x);
	}
	
	inline static function isSvn(x:String):Bool
	{
		return ~/\.svn/g.match(x);
	}
}