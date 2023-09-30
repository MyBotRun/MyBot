using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Diagnostics;
using System.Text.RegularExpressions;

namespace MbrCompiler
{
    class Program
    {
        public static string[] filesToCompile = { "MyBot.run", "MyBot.run.MiniGui", "MyBot.run.Watchdog", "MyBot.run.Wmi" };
        public static string[] endings = { "_stripped.au3", ".exe" };
        public static string zipFile = "MyBot.run.zip";
        public static string directory = Environment.CurrentDirectory;
        public static string versionFile = Path.Combine(directory, "MyBot.run.version.au3");
        public static Boolean debugBuild;
        public static string filesToZip = "COCBot\\* CSV\\* Help\\* images\\* imgxml\\* Languages\\* lib\\* Strategies\\* License.txt \"MyBot.run Community Support Key.asc\" README.md CHANGELOG MyBot.run.au3 MyBot.run.exe MyBot.run.MiniGui.au3 MyBot.run.MiniGui.exe MyBot.run.txt MyBot.run.version.au3 MyBot.run.Watchdog.au3 MyBot.run.Watchdog.exe MyBot.run.Wmi.au3 MyBot.run.Wmi.exe";
        public static string filesToZipDebug = filesToZip + " EnableMBRDebug.txt";

        static void Main(string[] args)
        {
            Console.WriteLine("##################################");
            Console.WriteLine("#                                #");
            Console.WriteLine("#   Starting to Compile Mybot    #");
            Console.WriteLine("#                                #");
            Console.WriteLine("##################################");
            Console.WriteLine("");

            //Remove all old _stripped.au3 and .exe Files from Directory
            if (!removeExistingFiles()) return;

            //Add, Remove or Update Beta Tag on Version File
            if (confirmPrompt("Is it a Beta Release?") & File.Exists(versionFile))
            {
                addBetaTag();
                debugBuild = true;
            }
            else
            {
                removeBetaTag();
                debugBuild = false;
            }

            //Start Compilation
            foreach (string file in filesToCompile)
            {
                //Au3 Checker
                int checkerCode = runTool("Au3Check.Exe", Path.Combine(directory, file + ".au3"));
                if (checkerCode == 0)
                {
                    Console.ForegroundColor = ConsoleColor.Green;
                    Console.WriteLine("Au3Checker successfully on {0}.au3", file);
                    Console.ForegroundColor = ConsoleColor.Gray;
                }

                /* No more stripping per direction of TFKNazGul

                                //Au3 Stripper
                                runTool(Path.Combine("au3stripper", "au3stripper.exe"), Path.Combine(directory, file + ".au3"));
                */

                //Aut2Exe
                //string arg = string.Format(@" /In ""{0}"" /nopack /comp 2", Path.Combine(directory, file + "_stripped.au3"));
                string arg = string.Format(@" /In ""{0}"" /nopack /comp 2", Path.Combine(directory, file + ".au3"));
                runTool(Path.Combine("aut2exe", "aut2exe.exe"), arg, false);
                if (!File.Exists(Path.Combine(directory, file + ".exe")))
                {
                    Console.WriteLine("Error while compiling {0}.exe. Stopping", file);
                    goto Finish;
                }
            }

            //7Zip
            //Console.WriteLine("Start to Zip" + " '" + filesToZipDebug + "'");
            Console.WriteLine("Starting to Zip");
            string version = getVersion();

            if (!debugBuild)
            {
                //runTool("7z.exe", @"a -x!*.7z -x!*.zip -x!*.snk -x!*.lnk -xr!BackUp -xr!SmartFarm -x!*.sqlite3 -x!.git* -x!Profiles -x!build*.bat -x!build -x!build\* -x!installer -x!installer\* -x!OLD*CODE -x!DEV*TOOLS -x!Zombies -x!Zombies\* -x!SkippedZombies -x!SkippedZombies\* -x!lib\*Debug* -x!*Debug*.txt -x!BuildMBR* -x!*_stripped.au3 -x!CHANGELOG* -x!lib\*Debug*\* -x!*debug-txt -x!*TODO.txt -x!lib\*.txt -x!lib\*.html  -r MyBot-MBR_" + version + ".zip *", false);
                runTool("7z.exe", "a MyBot-MBR_" + version + ".zip " + filesToZip, false);
            }
            else
            {
                // Include EnableMBRDebug.txt flag file for debug builds
                // runTool("7z.exe", @"a -x!*.7z -x!*.zip -x!*.snk -x!*.lnk -xr!BackUp -xr!SmartFarm -x!*.sqlite3 -x!.git* -x!Profiles -x!build*.bat -x!build -x!build\* -x!installer -x!installer\* -x!OLD*CODE -x!DEV*TOOLS -x!Zombies -x!Zombies\* -x!SkippedZombies -x!SkippedZombies\* -x!lib\*Debug* -x!BuildMBR* -x!*_stripped.au3 -x!CHANGELOG* -x!lib\*Debug*\* -x!*debug-txt -x!lib\*.txt -x!lib\*.html  -r MyBot-MBR_" + version + ".zip *", false);
                runTool("7z.exe", "a MyBot-MBR_" + version + ".zip " + filesToZipDebug, false);
            }
            goto Finish;


        Finish:
            // There or not, attempt to get rid of the addition to the version file.
            removeBetaTag();

            Console.WriteLine("{0}Press any key to exit", Environment.NewLine);
            Console.ReadKey();
        }

        private static bool confirmPrompt(string text)
        {
            Console.Write(string.Format("{0} [Y/N] : ", text));
            ConsoleKey response = Console.ReadKey(false).Key;
            Console.WriteLine();
            if (response == ConsoleKey.Escape) System.Environment.Exit(1);
            return (response == ConsoleKey.Y);
        }

        private static bool removeExistingFiles()
        {
            foreach (string file in filesToCompile)
            {
                foreach (string ending in endings)
                {
                    string fullFilePath = Path.Combine(directory, file + ending);
                    if (File.Exists(fullFilePath))
                    {
                        Console.WriteLine("Deleting {0}", fullFilePath);
                        File.Delete(fullFilePath);
                        if (File.Exists(fullFilePath))
                        {
                            Console.WriteLine("Error while deleting {0}. Stopping Compilation!", fullFilePath);
                            return false;
                        }
                    }
                }
            }

            if (File.Exists(Path.Combine(directory, zipFile)))
            {
                File.Delete(Path.Combine(directory, zipFile));
                if (File.Exists(Path.Combine(directory, zipFile)))
                {
                    Console.WriteLine("Error while deleting {0}. Stopping", zipFile);
                    return false;
                }
            }

            return true;
        }

        private static int runTool(string path, string arguments, bool addQuotesToArgs = true)
        {
            try
            {
                var process = new Process
                {
                    StartInfo = new ProcessStartInfo
                    {
                        FileName = Path.Combine(directory, "build", path),
                        Arguments = addQuotesToArgs ? '"' + arguments + '"' : arguments,
                        UseShellExecute = false,
                        RedirectStandardOutput = true,
                        RedirectStandardError = true,
                        CreateNoWindow = true
                    }
                };
                process.Start();

                while (!process.StandardOutput.EndOfStream || !process.StandardError.EndOfStream)
                {
                    if (!process.StandardOutput.EndOfStream)
                    {
                        var line = process.StandardOutput.ReadLine();
                        Console.WriteLine(line);
                    }
                    if (!process.StandardError.EndOfStream)
                    {
                        var errorLine = process.StandardError.ReadLine();
                        Console.WriteLine("[E]: {0}", errorLine);
                    }
                }
                process.WaitForExit();

                return process.ExitCode;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return -1;
            }

        }

        private static void addBetaTag()
        {
            string content = File.ReadAllText(versionFile);
            //Get standalone version string
            string version = Regex.Match(content, @"v[0-9]+[\.0-9]*[\.0-9]*").Value;
            //Format new version string "v.X.Y.x byy.MM.dd"
            string newVersion = string.Format("{2}{0} b{1}{2}", version, DateTime.UtcNow.ToString("yy.MM.dd"), '"');
            //Replace old stuff between "" with new formatted version
            content = Regex.Replace(content, "\"v.*\"", newVersion);
            File.WriteAllText(versionFile, content);

            Console.WriteLine("Version changed to: {0}", newVersion);
        }

        private static string getVersion()
        {
            string content = File.ReadAllText(versionFile);
            string version = Regex.Match(content, @"v[0-9]+[\.0-9]*[\.0-9]*.*""").Value;
            version = Regex.Replace(version, @"""", "");
            version = Regex.Replace(version, @"\s", "_");
            return version;
        }

        private static void removeBetaTag()
        {
            string content = File.ReadAllText(versionFile);
            content = Regex.Replace(content, @"[\s]*b[0-9][\.0-9]*", string.Empty);
            File.WriteAllText(versionFile, content);
        }
    }
}
