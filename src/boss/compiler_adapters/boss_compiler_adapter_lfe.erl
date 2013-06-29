-module(boss_compiler_adapter_lfe).
-compile(export_all).

file_extensions() -> ["lfe"].

controller_module(AppName, Controller) -> lists:concat([AppName, "_", Controller, "_controller"]).

module_name_for_file(_AppName, File) -> filename:basename(File, ".lfe").

compile_controller(File, Options) ->
    do_compile(File, Options). 

compile(File, Options) ->
    do_compile(File, Options).

do_compile(File, Options) ->
    case lfe_comp:file(File, lfe_compiler_options(Options)) of
        {ok, Module, _Warnings} ->
            {ok, Module};
        Other ->
            Other
    end.

lfe_compiler_options(Options) ->
    CompilerOptions = [verbose, return, proplists:get_value(compiler_options, Options, [])],
    case proplists:get_value(out_dir, Options) of
        undefined -> CompilerOptions;
        OutDir -> [{outdir, OutDir} | CompilerOptions]
    end.
