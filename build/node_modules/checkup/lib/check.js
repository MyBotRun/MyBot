(function(global) {
    'use strict';
    
    if (typeof module === 'object' && module.exports)
        module.exports = new checkProto();
    else if (!global.check)
        global.check = new checkProto();
    
    function checkProto() {
        /**
         * Check is all arguments with names present
         * 
         * @param name
         * @param arg
         * @param type
         */
        var check = function check(args, names) {
            var template    = ' could not be empty!';
            
            if (names)
                checkArray(args, names, template);
            else
                Object.keys(args).forEach(function(name) {
                    if (typeof args[name] === 'undefined')
                        throw Error(name + template);
                });
            
            return check;
        };
        
        function checkArray(args, names, template) {
            var name,
                isEmpty,
                indexOf     = Array.prototype.indexOf,
                lenNames    = names.length,
                lenArgs     = args.length,
                lessArgs    = lenArgs < lenNames,
                emptyIndex  = indexOf.call(args);
                
                if (~emptyIndex)
                    isEmpty     = emptyIndex + 1 <= lenNames;
                    
                if (lessArgs || isEmpty) {
                    if (lessArgs)
                        name        = names[lenNames - 1];
                    else
                        name        = names[emptyIndex];
                    
                    throw Error(name + template);
                }
        }
        
        check.check = check;
        
        /**
         * Check is type of arg with name is equal to type
         * 
         * @param name
         * @param arg
         * @param type
         */
        check.type  = function(name, arg, type) {
            var is = getType(arg) === type;
            
            if (!is)
                throw Error(name + ' should be ' + type);
            
            return check;
        };
        
        function getType(variable) {
            var regExp      = new RegExp('\\s([a-zA-Z]+)'),
                str         = {}.toString.call(variable),
                typeBig     = str.match(regExp)[1],
                result      = typeBig.toLowerCase();
            
            return result;
        } 
        
        return check;
    }
    
})(this);
