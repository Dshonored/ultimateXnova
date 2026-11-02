<?php
/**
 * Smarty plugin
 *
 * @package    Smarty
 * @subpackage PluginsFilter
 */
/**
 * Smarty time modifier
 *
 * @param string                    $source input string
 * @param \Smarty_Internal_Template $template
 *
 * @return string filtered output
 */
function smarty_modifier_time($timeInSeconds)
{
    // A duration, not a clock time: gmdate() so the server timezone never shifts it,
    // and whole days are shown instead of wrapping around (86400s used to print 00:00:00).
    $seconds = max(0, (int) $timeInSeconds);
    $days    = intdiv($seconds, 86400);
    $clock   = gmdate('H:i:s', $seconds % 86400);

    if ($days > 0) {
        return $seconds % 86400 === 0 ? $days.'d' : $days.'d '.$clock;
    }
    return $clock;
}
